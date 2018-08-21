codeunit 123456799 InstallSeminar
{
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    begin
        if SetupExists then
            exit;
        InitSetup;
        CreateSeminar;
        CreateResources;
    end;

    local procedure InitSetup();
    var
        NoSerie: Record "No. Series";
        NoSerieLine: Record "No. Series Line";
        SeminarSetup: Record "CSD Seminar Setup";
        SourceCodeSetup: Record "Source Code Setup";
        SourceCode: Record "Source Code";
    begin
        SetupExists := SeminarSetup.get;
        if SetupExists then
            exit;

        SeminarSetup.init;
        if SeminarSetup.Insert then;

        NoSerie.Code := 'SEM';
        NoSerie.Description := 'Seminars';
        NoSerie."Default Nos." := true;
        NoSerie."Manual Nos." := true;

        if NoSerie.Insert then;

        NoSerieLine."Series Code" := NoSerie.Code;
        NoSerieLine."Starting No." := 'SEM0000';
        if NoSerieLine.Insert then;
        SeminarSetup."Seminar Nos." := NoSerie.code;

        NoSerie.Code := 'SEMREG';
        NoSerie.Description := 'Seminar Registrations';
        NoSerie."Default Nos." := true;
        NoSerie."Manual Nos." := false;
        if NoSerie.Insert then;

        NoSerieLine."Series Code" := NoSerie.Code;
        NoSerieLine."Starting No." := 'SEMREG0000';
        if NoSerieLine.Insert then;
        SeminarSetup."Seminar Registration Nos." := NoSerie.code;

        NoSerie.Code := 'SEMREGPOST';
        NoSerie.Description := 'Posted Seminar Registrations';
        NoSerie."Default Nos." := true;
        NoSerie."Manual Nos." := true;
        if NoSerie.Insert then;

        NoSerieLine."Series Code" := NoSerie.Code;
        NoSerieLine."Starting No." := 'SEMPREG0000';
        if NoSerieLine.Insert then;
        SeminarSetup."Posted Seminar Reg. Nos." := NoSerie.code;

        SeminarSetup.Modify;

        SourceCode.Code := 'SEMINAR';
        if SourceCode.Insert then;
        SourceCodeSetup.get;
        //SourceCodeSetup."CSD Seminar" := 'SEMINAR';
        SourceCodeSetup.modify;
    end;

    local procedure CreateSeminar();
    var
        Seminar: Record "CSD Seminar";
        Course: Record Course;
    begin
        if Course.FindSet then repeat
            Seminar.Init;
            Seminar."No." := Course.Code;
            Seminar.Name := Course.Description;
            Seminar."Seminar Price" := Course.Price;
            Seminar."Seminar Duration" := Course.Duration;
            Seminar."Gen. Prod. Posting Group" := 'MISC';
            Seminar."VAT Prod. Posting Group" := 'VAT25';
            Seminar."Minimum Participants" := 4;
            Seminar."Maximum Participants" := 12;
            IF Seminar.Insert then;
        until Course.Next = 0;
    end;

    local procedure CreateResources();
    var
        Resource: Record Resource;
    begin
        Resource.init;
        Resource."No." := 'INSTR';
        Resource.Name := 'Mr. Instructor';
        Resource.validate("Gen. Prod. Posting Group", 'MISC');
        Resource."Direct Unit Cost" := 100;
        Resource."CSD Quantity Per Day" := 8;
        Resource.Type := Resource.Type::Person;
        if Resource.Insert then;
        Resource."No." := 'ROOM 01';
        Resource.Name := 'Room 01';
        Resource.Type := Resource.Type::Machine;
        if Resource.Insert then;
    end;

    /* local procedure CreateSeminarRegistration();
    var
        SemRegHead: Record "CSD Seminar Reg. Header";
        SemRegLine: Record "CSD Seminar Registration Line";

    begin
        SemRegHead.init;
        SemRegHead.Insert(true);
        SemRegHead.Validate("Seminar No.", '80040');
        SemRegHead.Validate("Instructor Resource No.", 'INSTR');
        SemRegHead.Validate("Starting Date", calcdate('<+1w-cw>', WorkDate));
        SemRegHead.Validate("Room Resource No.", 'ROOM 01');
        SemRegHead.Modify;
        SemRegLine.Init;
        SemRegLine."Document No." := SemRegHead."No.";
        SemRegLine."Line No." := 10000;
        SemRegLine.validate("Bill-to Customer No.", '01121212');
        SemRegLine.Validate("Participant Contact No.", 'CT000018');
        SemRegLine.insert;
        SemRegLine."Line No." := 20000;
        SemRegLine.validate("Bill-to Customer No.", '01121212');
        SemRegLine.Validate("Participant Contact No.", 'CT100132');
        SemRegLine.insert;

    end;
 */
    var
        SetupExists: Boolean;
}